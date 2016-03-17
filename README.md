# Mac Dictionary Augmentor

Augments your Mac's spell check dictionary used by the spell checker and auto correct features you see while typing. Included is a parsed medical dictionary and a command to merge it into your current dictionary. More spell check dictionaries may be used by providing newline separated lists of words.

## Usage

Clone this repo and cd into the directory:

```
git clone https://github.com/DiegoSalazar/mac_dictionary_augmentor
cd mac_dictionary_augmentor
```

Run you'll have access to this command: 

```
./augment PATH_TO_TERMINOLOGY_FILE
```

You can provide the path to your own newline separated list of terms or you can use one of the included files:

```
./augment ./technical_terms.txt
```

Or:

```
./augment ./medical_terms.txt
```

## Note

The `augment` command uses the `killall AppleSpell` command to initiate a reset of that process. It will only start up again when it's needed i.e. you start typing in a system text field or text editor. So, in between each `augment` command you'll have to do this or the command will fail when it tries to kill a dead AppleSpell.

## References

[Quick Tip: Bulk Add Words to Your Mac's Spell Check Dictionary](http://computers.tutsplus.com/tutorials/quick-tip-bulk-add-words-to-your-macs-spell-check-dictionary--mac-60820)