const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const helmet = require("helmet");
const { RateLimiterMemory } = require("rate-limiter-flexible");
const connectDB = require("./config/db");
const userRoute = require("./router/userRouter");
const jobRoute = require("./router/jobRouter");
const app = express();

dotenv.config();
const PORT = process.env.PORT || 5000;
const NODE_ENV = process.env.NODE_ENV || "development";

app.use(express.json());
app.use(cors());
app.use(helmet());

app.use("/api/users/", userRoute);
app.use("/api/jobs/", jobRoute);

const rateLimiter = new RateLimiterMemory({
  points: 10,
  duration: 1,
});

app.use(async (req, res, next) => {
  try {
    await rateLimiter.consume(req.ip);
    next();
  } catch {
    res
      .status(429)
      .json({ message: "Too many requests, please try again later." });
  }
});

app.use((req, res, next) => {
  res.success = (data) => res.json({ success: true, data });
  res.error = (message, status = 500) =>
    res.status(status).json({ success: false, message });
  next();
});

connectDB();

if (NODE_ENV === "development") {
  console.log("Running in development mode");
} else {
  console.log("Running in production mode");
}

app.get("/api/health", (req, res) => {
  res.success({ message: "API is running smoothly!" });
});

const server = app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
});

process.on("SIGTERM", () => {
  console.log("SIGTERM received, shutting down gracefully...");
  server.close(() => {
    console.log("Server closed");
    process.exit(0);
  });
});

process.on("SIGINT", () => {
  console.log("SIGINT received, shutting down gracefully...");
  server.close(() => {
    console.log("Server closed");
    process.exit(0);
  });
});
