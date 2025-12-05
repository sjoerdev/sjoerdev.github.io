# script to auto generate project pages

# project github links
$projectUrls = @(
    "https://github.com/username/project1",
    "https://github.com/username/project2",
    "https://github.com/username/project3"
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

foreach ($url in $projectUrls)
{
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

    # hugo front matter
    $frontMatter = 
@"
---
title: "$repo"
date: $(Get-Date -Format "yyyy-MM-dd")
github: "$url"
---
"@

    # combine into final markdown page
    $finalContent = $frontMatter + "`n" + $readmeContent
    $outputFile = Join-Path $outputDir "$repo.md"
    $finalContent | Out-File -FilePath $outputFile -Encoding UTF8
}