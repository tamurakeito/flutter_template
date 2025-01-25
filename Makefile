json_server:
	npx json-server --watch json-server/db.json --routes json-server/routes.json --middlewares json-server/middleware.js --port 3004

mocks:
	dart run build_runner build