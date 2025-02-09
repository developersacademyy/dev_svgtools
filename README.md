# 📐 Geometric Shapes - svgtools

> Esta biblioteca utilitária serve para renderização de interfaces no Multi Theft Auto via SVG, permitindo a criação de formas geométricas, utilização versátil para huds, painéis e outros elementos visuais.

# Installation
- `1.` - Download MTA:SA on your machine: https://multitheftauto.com/
- `2.` - Download this repository.

# Explication

```lua
createPolygon('id', 'type', w, h, stroke)
```

| Parameter | Description                   |
| :-------- | :---------------------------- |
| `id`      | What is the polygon called.   |
| `type`    | Type of element.              |
| `w`       | Size of width.                |
| `h`       | Size of height.               |
| `stroke`  | Size of stroke.               |

```lua
createCircle('id', w, h, stroke)
```

| Parameter | Description                   |
| :-------- | :---------------------------- |
| `id`      | What is the polygon called.   |
| `type`    | Type of element.              |
| `w`       | Size of width.                |
| `h`       | Size of height.               |
| `stroke`  | Size of stroke.               |

```lua
updateVector('id', value)
```

| Parameter | Description                   |
| :-------- | :---------------------------- |
| `id`      | What is the polygon called.   |
| `value`   | Value to Offset in svg.       |

```lua
drawVector('id', x, y, color, rotX, rotY, rotZ, postGUI)
```

| Parameter | Description                   |
| :-------- | :---------------------------- |
| `id`      | What is the polygon called.   |
| `x`       | Size of x.                    |
| `y`       | Size of y.                    |
| `tocolor` | Color of polygon.             |
| `rotX`    | Polygon rotation in X.        |
| `rotY`    | Polygon rotation in Y.        |
| `rotZ`    | Polygon rotation in Z.        |
| `postGUI` | Define if the polygon is drawn over the graphical interface (true) or behind it (false). |
