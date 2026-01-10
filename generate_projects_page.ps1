# script to auto generate project pages

<#

    TODO: auto convert github video embed links to html embed video links

    <!-- github video format -->
    [](https://github.com/user-attachments/assets/9e318653-5ec1-4dc7-9071-c8a26ff5f471)

    <!-- html video format -->
    <video width="100%" controls>
        <source src="https://github.com/user-attachments/assets/9e318653-5ec1-4dc7-9071-c8a26ff5f471">
    </video>

#>

# project github links
$projectUrls = @(
    "https://github.com/sjoerdev/voxel-engine",
    "https://github.com/sjoerdev/concrete",
    "https://github.com/sjoerdev/fluid-simulation",
    "https://github.com/sjoerdev/fluid-simulation-vitagl",
    "https://github.com/sjoerdev/unity-mandelbulb"
)

# output directory
$outputDir = "content/projects"

# clean existing project files
if (Test-Path $outputDir)
{
    Remove-Item -Path $outputDir -Recurse -Force
}

# create new project files directory
New-Item -ItemType Directory -Path $outputDir | Out-Null

function KebabToTitle($text)
{
    # replace hyphens with spaces, and split into words
    $words = $text -replace '-', ' ' -split ' '
    
    # capitalize first letter of each word
    $words = $words | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) }
    
    # join back into a string
    return $words -join ' '
}

# helper function to convert github video links to HTML video embeds
function Convert-GitHubVideos($content) {
    # regex to match github video links: [](https://github.com/...)
    $pattern = "\[\]\((https://github\.com/user-attachments/assets/[a-f0-9\-]+)\)"

    # replace each match with HTML video embed
    return [regex]::Replace($content, $pattern, {
        param($match)
        $url = $match.Groups[1].Value
        return "<video width=`"100%`" controls>`n    <source src=`"$url`">`n</video>"
    })
}

foreach ($url in $projectUrls)
{
    $weight = $projectUrls.IndexOf($url) + 1

    # take username and reponame from url
    $path = $url.Replace("https://github.com/", "")
    $parts = $path.Split("/")
    $username = $parts[0]
    $repo = $parts[1]

    # readme urls to try for each project
    $readmeUrls = @(
        "https://raw.githubusercontent.com/$username/$repo/main/README.md",
        "https://raw.githubusercontent.com/$username/$repo/main/readme.md",
        "https://raw.githubusercontent.com/$username/$repo/master/README.md",
        "https://raw.githubusercontent.com/$username/$repo/master/readme.md"
    )

    $readmeContent = $null
    foreach ($rUrl in $readmeUrls)
    {
        try
        {
            $readmeContent = irm $rUrl
            break
        }
        catch
        {
            # should try other readme format
        }
    }

    $summary = (Invoke-RestMethod -Uri "https://api.github.com/repos/$username/$repo").description

    # hugo front matter
    $frontMatter = 
@"
---
title: "$(KebabToTitle $repo)"
summary: "$summary"
ShowBreadCrumbs: true
ShowToc: false
TocOpen: false
weight: $weight
---

> Download and source-code can be found [on this website]($url)

"@

    # combine into final markdown page
    $readmeContent = Convert-GitHubVideos $readmeContent
    $finalContent = $frontMatter + "`n" + $readmeContent
    $outputFile = Join-Path $outputDir "$repo.md"
    $finalContent | Out-File -FilePath $outputFile -Encoding UTF8
}