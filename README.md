# 📐 Biblioteca de Polígonos

> Esta biblioteca utilitária permite a renderização de formas geométricas no Multi Theft Auto via SVG, proporcionando a criação de polígonos de forma otimizada e prática.

# 📌 Como Funciona?

### Criação de Polígono
```lua
createPolygon(id, type, width, height, stroke)
```
| Parâmetro  | Descrição                       |
|------------|---------------------------------|
| `id`       | Identificador do polígono.      |
| `type`     | Tipo do elemento.               |
| `width`    | Largura do polígono.            |
| `height`   | Altura do polígono.             |
| `stroke`   | Espessura da borda (stroke).    |

### Atualização de Polígono
```lua
updatePolygon(id, value)
```
| Parâmetro  | Descrição                       |
|------------|---------------------------------|
| `id`       | Identificador do polígono.      |
| `value`    | Valor a ser atualizado no SVG.  |

### Desenhar um Polígono
```lua
drawPolygon(id, x, y, color, rotX, rotY, rotZ, postGUI)
```
| Parâmetro  | Descrição                                                      |
|------------|----------------------------------------------------------------|
| `id`       | Identificador do polígono.                                     |
| `x`        | Posição no eixo X.                                             |
| `y`        | Posição no eixo Y.                                             |
| `color`    | Cor do polígono (em formato RGBA ou HEX).                      |
| `rotX`     | Rotação do polígono no eixo X.                                 |
| `rotY`     | Rotação do polígono no eixo Y.                                 |
| `rotZ`     | Rotação do polígono no eixo Z.                                 |
| `postGUI`  | Define se o polígono será desenhado sobre (`true`) ou atrás (`false`) da interface gráfica. |

---

## 🚀 Como Utilizar?

### Exemplo de Uso
```lua
cache = {
    health = { false, 100, getTickCount() }
}

resourceStart = function()
      createPolygon('health', 'hexagon', 100, 100, 4)
end
addEventHandler('onClientResourceStart', resourceRoot, resourceStart)

resourceRender = function()
      drawPolygon('health', 400, 400, tocolor(255, 0, 0, 255))
      updatePolygon('health', getElementHealth(localPlayer))
end
addEventHandler('onClientRender', root, resourceRender)
```
      
> Esse exemplo cria um hexágono, atualiza seu vetor e o renderiza na tela.

💡 **Observação:** Essa biblioteca facilita a renderização de polígonos no MTA, permitindo um controle eficiente sobre os elementos gráficos por meio do SVG.
