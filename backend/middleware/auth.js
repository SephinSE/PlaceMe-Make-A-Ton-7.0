const jwt = require("jsonwebtoken");
const User = require("../model/users");

const authenticateJWT = async (req, res, next) => {
  const token =
    req.headers["authorization"] &&
    req.headers["authorization"].startsWith("Bearer ")
      ? req.headers["authorization"].split(" ")[1]
      : null;

  if (!token) {
    return res
      .status(401)
      .json({ message: "Access denied. No token provided." });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = await User.findById(decoded.userId).select("-password");
    if (!req.user) {
      return res.status(404).json({ message: "User not found" });
    }
    next();
  } catch (error) {
    return res
      .status(403)
      .json({ message: "Invalid or expired token. Please log in again." });
  }
};

const checkRole = (role) => {
  return (req, res, next) => {
    if (req.user.isPlaceCo === role) {
      next();
    } else {
      return res
        .status(403)
        .json({ message: `you don't have permission` });
    }
  };
};

module.exports = {
  authenticateJWT,
  checkRole,
};
