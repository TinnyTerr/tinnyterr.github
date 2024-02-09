# index.js

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

**Line [1](#__codelineno-0-1) and line [2](#__codelineno-0-2):** 
`fs` and `path` will be covered later with examples of their usage.

**Line [3](#__codelineno-0-3):** 
`discord.js` is self explanitory, it is one of the discord packages that 
allow you to communicate with discord and use discord bots.

**Line [4](#__codelineno-0-4):** 
`config.json` is found [here](./config.json.md).

**Line's [6](#__codelineno-0-7) and [7](#__codelineno-0-7):**
`Sentry` and `Sentry/profiling-node` are monitoring software found [here](https://sentry.io).

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

**Line [26](#__highlightcodelineno-3-26):** 
`commands` is an array defined to keep track of all the registered commands from the ./commands/ directory.

**Line [28](#__codelineno-3-28):** 
`client.commands()` is a function inside of previously defined [client](#defining-client) using discord's slash command function.

**Line [29](#__codelineno-3-29):** 
`foldersPath` defines where to look for the commands.

**Line [30](#__codelineno-3-30):** 
`commandFolders` reads all the files inside `folderPath` disregarding what file it is.

**Line [32](#__codelineno-3-32):** 
`for ...` repeats for every file in `folderPath`.

**Line [33](#__codelineno-3-33) to line [34](#__codelineno-3-34):** 
`commandsPath` and `commandFiles` read the VALID files defined in `foldersPath`. 

**Line [35](#__codelineno-3-35):** 
`for ...` repeats for every VALID command file.

**Line [37](#__codelineno-3-37):** 
`console.log` for debugging if errors arise.

**Line [38](#__codelineno-3-38) to line [39](#__codelineno-3-39):** 
Converts all commands and adds them to a json entry then makes the data within the commands accessible.

**Line [40](#__codelineno-3-40):** 
Check to make sure that commands are structured correctly
See [commands](./commands/index.md).

**Line [41](#__codelineno-3-41) to line [43](#__codelineno-3-43):** 
These lines add the commands to the defined array, add them to `client.commands` collection and make them usable through discord

**Line [44](#__codelineno-3-44) to line [46](#__codelineno-3-46):** 
Catching errors where command files are not populated with correct data

## Deploying Commands

``` javascript linenums="52"
const rest = new REST().setToken(token);

(async () => {
	try {
		console.log(`Started refreshing ${commands.length} application (/) commands.`);

		const data = await rest.put(
			Routes.applicationCommands(clientId),
			{ body: commands },
		);

		console.log(`Successfully reloaded ${data.length} application (/) commands`)
	} catch (error) {
		console.error(error);
		throw(error)
	}
})();
```
**Line [52](#__codelineno-4-52):**
Uses the bot's token to create a `REST` endpoint where it directly communicates with the Discord API and creates more functionality.

**Line [54](#__codelineno-4-54) to line [56](#__codelineno-4-56):**
Starting a async process where it creates a try catch statement and logs for debugging.
**Line [56](#__codelineno-4-56) to line [59](#__codelineno-4-59):**
This uses the extra functionality of `REST` to send a API request to refresh the commands attached to the bot. 

**Line [61](#__codelineno-4-61) to line [66](#__codelineno-4-66):**
These lines are purely debugging and documentation. See [here](https://) for catch documentation

``` javascript linenums="68"
const eventsPath = path.join(__dirname, 'events');
const eventFiles = fs.readdirSync(eventsPath).filter(file => file.endsWith('.js'));

for (const file of eventFiles) {
	console.log(`Started refreshing ${file}.`);
	const filePath = path.join(eventsPath, file);
	const event = require(filePath);
	if (event.once) {
		client.once(event.name, (...args) => event.execute(...args));
	} else {
		client.on(event.name, (...args) => event.execute(...args));
	}
	console.log(`Refreshed ${file}.`);
}

client.login(token);
```

**This is the same as [command registering](#get-commands-from-commands) but edited for events**

Events being:

onReady

InteractionCreate