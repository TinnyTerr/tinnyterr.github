# Index.js

## Packages

We start defining variables and packages we will be using.

```js linenums="1"
const fs = require('node:fs');
const path = require('node:path');
const { Routes, REST, Client, Collection, GatewayIntentBits } = require('discord.js');
const { clientId, token } = require('./config.json');

const Sentry = require('@sentry/node')
const { ProfilingIntegration } = require('@sentry/profiling-node') 
```

`fs` and `path` will be covered later with examples of their usage

`discord.js` is self explanitory, it is one of the discord packages that 
allow you to communicate with discord and use discord bots.

`config.json` is found [here](./config.json.md)

`Sentry` and `Sentry/profiling-node` are monitoring software found [here](https://sentry.io)

## [Optional] Sentry Monitoring

```js linenums="9"
Sentry.init({
	dsn: "", //NOTE: removed for privacy reasons
  // Performance Monitoring
  tracesSampleRate: 1.0,
  profilesSampleRate: 1.0, // Profiling sample rate is relative to tracesSampleRate
  integrations: [
    // Add profiling integration to list of integrations
    new ProfilingIntegration(),
  ],
});
```

`Sentry` is a monitoring software that is linked with discord to alert of any issues.

I use this for ease of use as I am on discord a lot however it is easy to remove and 
replace it if need be.

## Defining Client

```js linenums="20"
const client = new Client({ 
	intents: [
		GatewayIntentBits.Guilds, 
		GatewayIntentBits.GuildMembers
	]});
```

This is when I define client for the rest of the bot to get information from discord
and send messages to the API to respond. 

## Get commands from ./commands/

```js linenums="26"
const commands = []

client.commands = new Collection();
const foldersPath = path.join(__dirname, 'commands');
const commandFolders = fs.readdirSync(foldersPath);

for (const folder of commandFolders) {
	const commandsPath = path.join(foldersPath, folder);
	const commandFiles = fs.readdirSync(commandsPath).filter(file => file.endsWith('.js'));
	for (const file of commandFiles) {

		console.log(`Loading ${file}`)
		const filePath = path.join(commandsPath, file);
		const command = require(filePath);
		if ('data' in command && 'execute' in command) {
			client.commands.set(command.data.name, command);
			commands.push(command.data.toJSON());
			console.log(`Loaded ${file}`)
		} else {
			console.log(`[WARNING] The command at ${filePath} is missing a required "data" or "execute" property.`);
		}
		
	}
}
```

`commands` is an array defined to keep track of all the registered commands from the ./commands/ directory

`client.commands()` is a function inside of previously defined [client](#defining-client) using discord's slash command function

`foldersPath` defines where to look for the commands

`commandFolders` reads all the files inside `folderPath` disregarding what file it is

`for ...` repeats for every file in `folderPath`