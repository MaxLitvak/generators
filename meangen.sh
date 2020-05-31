#!/bin/bash

npm init
npm install express body-parser cookie-parser cors morgan mongoose nodemon
mkdir config
mkdir bin
mkdir models
mkdir routes
mkdir route-controllers
touch .gitignore
echo "# dependencies
/node_modules
.DS_Store" >> .gitignore
touch .jshintrc
echo '''{
	"esversion": 6,
  "undef": true,
  "node": "true"
}''' >> .jshintrc
cd bin
touch start
echo '''#!/usr/bin/env node

/**
 * Module dependencies.
 */

const app = require("../config/app");
const debug = require("debug")("meanmiltonforum:server");
const http = require("http");

/**
 * Get port from environment and store in Express.
 */

const port = normalizePort(process.env.PORT || "3000");
app.set("port", port);

/**
 * Create HTTP server.
 */

const server = http.createServer(app);

/**
 * Listen on provided port, on all network interfaces.
 */

server.listen(port);
console.log(`server started on port ${port}`);
server.on("error", onError);
server.on("listening", onListening);

/**
 * Normalize a port into a number, string, or false.
 */

function normalizePort(val) {
  const port = parseInt(val, 10);

  if (isNaN(port)) {
    // named pipe
    return val;
  }

  if (port >= 0) {
    // port number
    return port;
  }

  return false;
}

/**
 * Event listener for HTTP server "error" event.
 */

function onError(error) {
  if (error.syscall !== "listen") {
    throw error;
  }

  const bind = typeof port === "string" ? "Pipe " + port : "Port " + port;

  // handle specific listen errors with friendly messages
  switch (error.code) {
    case "EACCES":
      console.error(bind + " requires elevated privileges");
      process.exit(1);
      break;
    case "EADDRINUSE":
      console.error(bind + " is already in use");
      process.exit(1);
      break;
    default:
      throw error;
  }
}

/**
 * Event listener for HTTP server "listening" event.
 */

function onListening() {
  const addr = server.address();
  const bind = typeof addr === "string" ? "pipe " + addr : "port " + addr.port;
  debug("Listening on " + bind);
}''' >> start
cd ../config
touch app.js
echo '''const app = require("./express");
const config = require("./mongo");
console.log("app configured");

module.exports = app;''' >> app.js
touch database.js
echo '''module.exports = {
	database: "mongodb://db:password@localhost:27017/db",
	secret: "yourSecretKey"
};''' >> databse.js
touch express.js
echo '''const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const cors = require("cors");
// if you want passport install it via npm
// const passport = require("passport");
const logger = require("morgan");
const config = require("./database");

const app = express();

// morgan logger middleware
app.use(logger("dev"));
console.log("use morgan middleware");

// cors middleware
const corsOptions = {
  origin: "http://localhost:4200",
  credentials: true
};
app.use(cors(corsOptions));
console.log("use cors middleware");

// body-parser middleware
app.use(cookieParser(config.secret));
console.log("use cookie-parser middleware");

// cookie-parser middleware
app.use(bodyParser.json());
console.log("use body-parser middleware");

// passport middleware if you want
// app.use(passport.initialize());
// app.use(passport.session());
// passport.serializeUser((user, done) => done(null, user));
// passport.deserializeUser((user, done) => done(null, user));
// require("./passport")(passport);
// console.log("use passport middleware");

// static folder
app.use(express.static(path.join(__dirname, "../public")));
console.log("set static folder: public");

// example routes
// const routes = require("../routes/exampleRoutes");
// app.use("/api/example", routes);
// console.log("set example routes");

module.exports = app;''' >> express.js
touch mongo.js
echo '''const mongoose = require("mongoose");
const db = require("./database");

// connect to database
mongoose.connect(db.database, {useNewUrlParser: true});

// check connection
mongoose.connection.on("connected", () => {
	console.log("connected to databse " + db.database);
});

mongoose.connection.on("error", (err) => {
	console.log("database error: " + err);
});

module.exports = mongoose;''' >> mongo.js
touch passport.js
echo '''// if you want passport install it via npm
// const JwtStrategy = require("passport-jwt").Strategy;
// const ExtractJwt = require("passport-jwt").ExtractJwt;
const Model = require("../models/Model");
const config = require("./database");

const cookieExtractor = function(req) {
  let token = null;
  if (req && req.cookies) {
    token = req.cookies.SESSIONID;
  }
  return token;
};

module.exports = (passport) => {
	const opts = {
		jwtFromRequest: cookieExtractor,
		secretOrKey: config.secret
	};
	passport.use(new JwtStrategy(opts, (jwt_payload, done) => {
		// return done(err, false);
		// return done(null, false);
		// return done(null, user);
	}));
};''' >> passport.js
cd ../models
touch Model.js
echo '''const mongoose = require("mongoose");

// example schema
const exampleSchema = mongoose.Schema({
	firstName: String,
	lastName: String,
	email: String,
});

const User = module.exports = mongoose.model("User", exampleSchema);

// example method
module.exports.getUserById = (id, callback) => {
	User.findById(id, callback);
};''' >> Model.js
cd ../route-controllers
touch exampleController.js
echo '''//example method
exports.getUser = (req, res, next) => {
	// get user
}''' >> exampleController.js
cd ../routes
touch exampleRoutes.js
echo '''const express = require("express");
const passport = require("passport");
const router = express.Router();

const controller = require("../route-controllers/exampleController");

// example route
router.get("/user", controller.getUserById);

module.exports = router;''' >> exampleRoutes.js
cd ../
mkdir angular-src
ng new angular-src
cd angular-src
npm install jquery popper.js bootstrap
npm audit fix
sudo rm -r .git
cd ../
git init
touch directions
echo '''1. open anglular.json
2. under styles add ./node_modules/bootstrap/dist/css/bootstrap.min.css"
3. under scripts add "./node_modules/jquery/dist/jquery.min.js",
                     "node_modules/popper.js/dist/umd/popper.min.js",
                     "./node_modules/bootstrap/dist/js/bootstrap.min.js"
''' >> directions




