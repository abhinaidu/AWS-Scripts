#AWS Scripts

## Scripts for interfacing with AWS

### Contributing

1. Get the latest code, create a new branch from develop and submit a PR </br>
2. Nothing should be hardcoded, parameters should be exposed as a variable/input. </br>
3. Use tab space as 4/5 spaces </br>
4. Use meaningful variable names and provide proper comments. </br>
5. Document the usage in the tool specific folder README
6. Briefly document the tool and what it does in this main README
7. Push your code in a separate subfolder. </br>

Please also consider using code linting tools such as rubocop for ruby, flake8 or pylint for python, shellcheck for shell scripts.


### Existing projects

* copyAMI: Script to copy AMI to any regions using awscli </br>
* updateExpirationDateTag Script to update instance ExpirationDate tag in any region
