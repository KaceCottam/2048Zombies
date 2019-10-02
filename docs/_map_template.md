Maps
===

Maps are a `json` file that *MUST* include the following:

- size `(x : Number, y : Number)`
- win : `Number`
- police\_chance : `[Number] : size(police_chance) == win-1`

Optional parameters include:

- blocks : `[ (x : Number, y : Number) ]` = `[]`
- zombie\_initial : `( x : Number, y : Number, size : Number )`    
  = { `( 0..size.x, 0..size.y, 2 )` : $\exists A\in$blocks, (x,y) != A }

Example (maps/map0)
---

```json
{
  "size": { "x": 4, "y": 4 },
  "win": 3,
  "police_chance": [25, 100],
  "blocks": [ { "x": 0, "y": 0 }
            , { "x": 3, "y": 3 }
            ]
}
```

