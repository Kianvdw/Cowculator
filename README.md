# Cowculator

Cowculator is a Flutter application designed to provide reliable livestock weight estimates using body measurement formulas validated by agricultural extension services and veterinary research.  

The app is intended as a practical tool for farmers, students, and professionals who need quick weight estimates in the field without access to a scale.  

---

## Features

- Support for multiple livestock species, starting with **cattle** and **horses**.  
- Implementation of well-established weight estimation formulas from extension studies (Schaeffer, Hassen Regression, Yamato, Girth-only for cattle; Adult, Yearling, and Foal methods for horses).  
- Global unit system toggle (**metric** or **imperial**) applied consistently across the app.  
- Clear display of estimated weight alongside the method-specific margin of error.  
- Consistent Material 3 interface with light/dark theme support.  
- Offline use — no internet connection required.  

---

## Reference formulas

- **Cattle — Schaeffer formula:** (HG² × BL) ÷ 300 (Oregon State University Extension).  
- **Horses — Adult:** (HG² × BL) ÷ 330 (University Extension examples).  
- **Horses — Yearling:** divisor 301.  
- **Horses — Foal/Weanling:** divisor 280.  
- **Horses — Metric (kg):** (HG² × BL) ÷ 11 877 (Carroll & Huntington, 1988).  

Where available, accuracy ranges are based on the same published sources.

---

## Roadmap

- Add support for sheep, pigs, and goats.  
- Basic herd management functionality (record keeping for multiple animals).  
- Cloud backup and device sync.  

---

## Tech stack

- Flutter with Dart  
- Provider for state management  
- Material 3 theming  

---

## Contributing

Contributions are welcome. If you are interested in improving formulas, expanding species coverage, or refining the UI/UX, please fork the repository and open a pull request.  

---

## License

MIT License — free to use, modify, and share.
