# Reconstrucción de señales periódicas con series de Fourier

Universidad del Cauca - Facultad de Ingeniería Electrónica y Telecomunicaciones

## Integrante
- Victor Hugo Samboni


## Descripción
Aplicación en MATLAB con interfaz gráfica que reconstruye señales periódicas
(cuadrada, triangular y diente de sierra, amplitud 1, periodo T = 1 s) a partir
de su serie trigonométrica de Fourier, y permite analizar el efecto del número
de armónicos N en la calidad de la reconstrucción.

La serie se calcula con coeficientes analíticos y sumas explícitas, sin usar
`fft` ni funciones de alto nivel.

## Archivos
| Archivo | Función |
|---|---|
| `fourier_app.m` | Interfaz gráfica (selección de señal, N e intervalo; gráficas y métricas) |
| `calcular_tabla.m` | Tabla de resultados (MSE y potencias vs N), gráficas y exportación a Excel |
| `coeficientes.m` | Coeficientes a0, ak, bk de cada señal |
| `senal.m` | Señal periódica original |
| `reconstruir.m` | Suma de los N primeros armónicos |

## Cómo ejecutar
1. Clonar o descargar el repositorio y abrir MATLAB en esa carpeta.
2. Interfaz gráfica:
   ```matlab
   fourier_app
   ```
3. Tabla de resultados y gráficas:
   ```matlab
   calcular_tabla
   ```
   Genera `resultados_fourier.xlsx`.

## Funcionalidades
- Señales: A (cuadrada), B (triangular), C (diente de sierra).
- N de armónicos: 1, 2, 3, 5, 10, 20, 50, 100, 150, 200.
- Gráficas: señal original, reconstruida, error |x(t) - x^(t)| y espectro de línea.
- Métricas: MSE (definición del enunciado, con raíz cuadrada), potencia de la
  señal original y potencia de la señal reconstruida (con verificación por Parseval).
- Las métricas se calculan sobre un periodo completo, por lo que son
  reproducibles e independientes del intervalo de visualización.

## Series utilizadas (ω0 = 2π/T)
- Cuadrada: x(t) = (4/π) Σ sen(kω0t)/k, k impar
- Triangular: x(t) = (8/π²) Σ cos(kω0t)/k², k impar
- Diente de sierra: x(t) = (2/π) Σ (-1)^(k+1) sen(kω0t)/k
# proyecto-fourier-matlab
