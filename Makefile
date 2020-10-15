fmt:
	fd '.dhall' -x dhall format --inplace

dhall-lint:
	fd '.dhall' -x dhall lint --inplace

lint:
	pre-commit run --all

freeze:
	fd 'package.dhall' -x dhall --ascii freeze --inplace {} --all

examples: lint
	shake generate

clean:
	shake clean
