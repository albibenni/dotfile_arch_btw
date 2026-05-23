# System Configuration Scripts

Scripts for system-wide configuration.

## Available Scripts

### `italian-setup.sh`
Sets up Italian language support while keeping English as the primary system language:
- Installs `hunspell-en_us`, `hyphen-en`, `hunspell-it`, and `hyphen-it`.
- Enables `it_IT.UTF-8` in `/etc/locale.gen`.
- Generates locales.
- Configures `/etc/locale.conf` to use Italian for regional formats (time, currency, paper, measurement).

**Usage:**
```bash
bash italian-setup.sh
```
