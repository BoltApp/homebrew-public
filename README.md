# BoltApp Public

## How do I install these formulae?

`brew install boltapp/public/<formula>`

Or `brew tap boltapp/public` and then `brew install <formula>`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## dynamodb-local

```bash
brew install --HEAD boltapp/public/dynamodb-local
# run in background
brew services start dynamodb-local
# run in foreground
dynamodb-local
```

* [removal](https://github.com/Homebrew/homebrew-core/pull/9175/files)
* [boneyard formula](https://github.com/rjcoelho/homebrew-boneyard/blob/master/Formula/dynamodb-local.rb)
