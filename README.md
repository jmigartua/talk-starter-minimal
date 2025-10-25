# Talk Starter · Minimal brands, shared palette

## Requires
- Quarto ≥ 1.6

## Use
```bash
quarto preview --profile posit   # Inter (Posit-like)
quarto preview --profile ehu-eu  # EHUSerif-first (Basque-first)
quarto preview --profile ehu-es  # EHUSans-first (Spanish-first)
```

## Fonts
Place files here:
- Inter: `_extensions/thermomat/ehu/fonts/Inter/Inter-Variable.woff2` (+ italic)
- EHUSans: `_extensions/thermomat/ehu/fonts/EHU_Sans/...`
- EHUSerif: `_extensions/thermomat/ehu/fonts/EHU_Serif/...`

All @font-face rules and color utilities live in `_extensions/thermomat/ehu/styles/brand-core.css`.
Each brand YAML only selects families/weights so colors are shared across skins.
