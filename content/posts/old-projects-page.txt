---
title: "Projects"
url: "/projects"
---

<style>
.image-grid
{
    display: grid;
    grid-template-columns: repeat(3, auto);
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
    border-radius: inherit;
}

.image-link:hover
{
    cursor: pointer !important;
}

.image-link
{
    all: unset !important;
}

.overlay-container
{
    position: relative;
    display: inline-block;
    border-radius: 8px;
}

.overlay-text
{
    display: flex;
    justify-content: center;
    align-items: center;
    text-align: center;
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    color: white;
    font-weight: bold;
    opacity: 0;
    transition: opacity 0.3s ease;
    border-radius: inherit;
}

.overlay-text:hover
{
    opacity: 1;
    background-color: rgba(0, 0, 0, 0.5);
}
</style>

<div class="image-grid">
    <a class="image-link" href="https://github.com/sjoerdev/voxel-engine" target="_blank">
        <div class="overlay-container">
            <img src="/images/voxelengine.png">
            <div class="overlay-text">Voxel Engine</div>
        </div>
    </a>
    <a class="image-link" href="https://github.com/sjoerdev/concrete" target="_blank">
        <div class="overlay-container">
            <img src="/images/concrete.png">
            <div class="overlay-text">Concrete Engine</div>
        </div>
    </a>
    <a class="image-link" href="https://github.com/sjoerdev/unity-mandelbulb" target="_blank">
        <div class="overlay-container">
            <img src="/images/mandelbulb.png">
            <div class="overlay-text">Mandelbulb Fractal</div>
        </div>
    </a>
    <a class="image-link" href="https://github.com/sjoerdev/gradius-clone" target="_blank">
        <div class="overlay-container">
            <img src="/images/gradiusclone.png">
            <div class="overlay-text">Gradius Clone</div>
        </div>
    </a>
    <a class="image-link" href="https://github.com/sjoerdev/lean" target="_blank">
        <div class="overlay-container">
            <img src="/images/lean.png">
            <div class="overlay-text">Lean Framework</div>
        </div>
    </a>
</div>