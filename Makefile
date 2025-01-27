dev:
	flutter run -t lib/main_development.dart

local:
	flutter run -t lib/main_local.dart

prd:
	flutter run -t lib/main_production.dart

jsv:
	./node_modules/.bin/json-server --watch json-server/db.json --routes json-server/routes.json --middlewares json-server/middleware.js --port 3004

mocks:
	dart run build_runner build