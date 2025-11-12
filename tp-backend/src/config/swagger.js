const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Sport App API',
      version: '1.0.0',
      description: 'API pour application de suivi sportif'
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Serveur de développement'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      },
      schemas: {
        Goal: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              example: 1
            },
            user_id: {
              type: 'integer',
              example: 1
            },
            title: {
              type: 'string',
              example: 'Courir 100 km ce mois'
            },
            description: {
              type: 'string',
              example: 'Objectif de course à pied pour le mois'
            },
            type: {
              type: 'string',
              enum: ['duration', 'distance', 'calories', 'activities_count'],
              example: 'distance'
            },
            target_value: {
              type: 'number',
              example: 100
            },
            current_value: {
              type: 'number',
              example: 45.5
            },
            start_date: {
              type: 'string',
              format: 'date',
              example: '2025-11-01'
            },
            end_date: {
              type: 'string',
              format: 'date',
              example: '2025-11-30'
            },
            status: {
              type: 'string',
              enum: ['active', 'completed', 'cancelled'],
              example: 'active'
            },
            created_at: {
              type: 'string',
              format: 'date-time'
            },
            updated_at: {
              type: 'string',
              format: 'date-time'
            }
          }
        }
      }
    }
  },
  apis: ['./src/routes/*.js']
};

module.exports = swaggerJSDoc(options);