const app = require('./src/app');

const startPort = parseInt(process.env.PORT, 10) || 3000;
const maxAttempts = 10;
let attempts = 0;

const tryListen = (port) => {
	attempts += 1;
	const server = app.listen(port, () => {
		console.log(`🚀 Serveur démarré sur le port ${port}`);
		console.log(`📚 Documentation: http://localhost:${port}/api-docs`);
	});

	server.on('error', (err) => {
		if (err && err.code === 'EADDRINUSE') {
			console.warn(`Port ${port} déjà utilisé.`);
			if (attempts < maxAttempts) {
				const nextPort = port + 1;
				console.log(`Tentative pour démarrer sur le port ${nextPort} (essai ${attempts + 1}/${maxAttempts})...`);
				setTimeout(() => tryListen(nextPort), 100);
			} else {
				console.error(`Impossible de trouver un port libre après ${maxAttempts} tentatives. Définissez une autre valeur pour PORT ou libérez le port.`);
				console.error(`Sur Windows : netstat -ano | findstr :<port>  puis taskkill /PID <PID> /F`);
				process.exit(1);
			}
		} else {
			console.error('Erreur du serveur :', err);
			process.exit(1);
		}
	});
};

tryListen(startPort);
