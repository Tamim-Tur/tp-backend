const Joi = require('joi');

const registerValidation = (req, res, next) => {
  const schema = Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().min(6).required()
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }
  next();
};

const activityValidation = (req, res, next) => {
  const schema = Joi.object({
    type: Joi.string().valid('running', 'cycling', 'swimming', 'walking', 'gym').required(),
    duration: Joi.number().min(1).required(),
    calories: Joi.number().min(0),
    distance: Joi.number().min(0),
    notes: Joi.string().max(500)
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }
  next();
};

module.exports = { registerValidation, activityValidation };