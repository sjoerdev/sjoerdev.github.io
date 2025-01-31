---
title: "Projects"
url: "/projects"
---

<style>
.image-grid
{
    display: grid;
    grid-template-columns: repeat(4, auto);
    grid-template-rows: repeat(6, auto);
    gap: 10px;
    width: 100%;
    margin: auto;
}

@media (orientation: portrait)
{
    .image-grid
    {
        grid-template-columns: repeat(2, auto);
    }
}

.image-grid img
{
    width: 100%;
    height: auto;
    display: block;
    margin: 0;
    padding: 0;
}

.image-link:hover
{
    cursor: pointer !important;
}

.image-link
{
    all: unset !important;
}
</style>

<div class="image-grid">
    <a class="image-link" href="https://github.com/sjoerdev/voxel-engine" target="_blank"><img src="/images/voxelengine.png"></a>
    <a class="image-link" href="https://github.com/sjoerdev/concrete" target="_blank"><img src="/images/concrete.png"></a>
    <a class="image-link" href="https://github.com/sjoerdev/unity-mandelbulb" target="_blank"><img src="/images/mandelbulb.png"></a>
    <a class="image-link" href="https://github.com/sjoerdev/gradius-clone" target="_blank"><img src="/images/gradiusclone.png"></a>
    <a class="image-link" href="https://github.com/sjoerdev/lean" target="_blank"><img src="/images/lean.png"></a>
</div>