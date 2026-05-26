```
Benchmark demo: RUNNING...
All
  string
    naive (BASE):          OK
      1.35 μs ± 110 ns
    interpolated:          OK
      1.35 μs ± 123 ns, 1.00x
  text
    naive (BASE):          OK
      241  ns ±  14 ns
    interpolated:          OK
      2.20 μs ± 117 ns, 9.10x
    interpolated explicit: OK
      249  ns ±  13 ns, 1.03x
  text qualified
    naive (BASE):          OK
      296  ns ±  24 ns
    interpolated:          OK
      292  ns ±  26 ns, 0.99x
    interpolated explicit: OK
      296  ns ± 5.5 ns, 1.00x
  text builder
    naive (BASE):          OK
      1.05 μs ±  67 ns
    interpolated:          OK
      3.10 μs ± 249 ns, 2.95x
    explicit:              OK
      1.06 μs ±  80 ns, 1.01x
```