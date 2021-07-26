## Release a new tag

To release a new tag follow these steps:

- Make sure you are on _master_ branch.

- Run the following commands

  ```
  cd bin

  # Only pass one value from [major, minor, patch]
  # ./tag.sh [major, minor, patch]
  # for example

  ./tag.sh patch
  ```

- When prompted check the tag number before continuing

  ```
  # example
  New tag will be: v1.0.0. Do you want to continue ? [y/n]:
  ```

- If you wish to _ABORT_, enter `n` to exit the process.
- If you wish to continue, enter `y` to push the tag.
