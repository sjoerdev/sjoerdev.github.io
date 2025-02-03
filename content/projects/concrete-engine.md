---
title: "Concrete Engine"
summary: "Modern .NET 9 based game engine"
description: "Modern .NET 9 based game engine"

cover:
    image: "images/concrete/concrete5.png"

ShowBreadCrumbs: true
ShowToc: false
TocOpen: false

weight: 2
---

> Download and source-code can be found [on this website](https://github.com/sjoerdev/concrete)

## Features

- unity inspired structure
- component based architecture
- simple imgui based editor
- simple opengl renderer
- supports any model file
- skeletal animation

## Usage Example
```csharp
var testScene = new Scene();
SceneManager.LoadScene(testScene);

var cameraObject = GameObject.Create();
cameraObject.AddComponent<Camera>();
cameraObject.name = "Camera";

var modelObject = GameObject.Create();
modelObject.AddComponent<ModelRenderer>().modelPath = "res/models/cesium.glb";
modelObject.name = "Cesium Model";

var lightObject = GameObject.Create();
lightObject.AddComponent<DirectionalLight>();
lightObject.transform.localEulerAngles = new Vector3(20, 135, 0);
lightObject.name = "Directional Light";
```

## Gallery
![](/images/concrete/concrete1.png)
![](/images/concrete/concrete2.png)
![](/images/concrete/concrete3.png)