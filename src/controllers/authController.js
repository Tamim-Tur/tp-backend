const AuthService = require('../services/authService');
exports.register = async (req, res, next) => {
  try {
    const user = await AuthService.register(req.body.email, req.body.password);
    res.status(201).json({
      message: 'Utilisateur créé avec succès',
      user: {
        id: user.id,
        email: user.email,
        role: user.role
      }
    });
  } catch (error) {
    next(error);
  }
};

exports.login = async (req, res, next) => {
  try {
    const result = await AuthService.login(req.body.email, req.body.password);
    res.json(result);
  } catch (error) {
    next(error);
  }
};

exports.refresh = async (req, res, next) => {
  try {
    const { refreshToken } = req.body;
    const result = await AuthService.refreshToken(refreshToken);
    res.json(result);
  } catch (error) {
    next(error);
  }
};