# embed.js

``` javascript linenums="1"
const { StringSelectMenuBuilder, StringSelectMenuOptionBuilder, SlashCommandBuilder, EmbedBuilder, ActionRowBuilder  } = require('discord.js');
```
**Line [31](#__codelineno-0-1):**
Defining `StringSelectMenuBuilder, StringSelectMenuOptionBuilder, SlashCommandBuilder, EmbedBuilder, ActionRowBuilder` from `discord.js.` package.
``` javascript linenum="3"
 
module.exports = {
    category: "ticket",
    data: new SlashCommandBuilder()
        .setName("ticket-embed")
        .setDescription("Sends the ticket embed"),
```
**Line [3](#__codelineno-1-3):**
Defining what data to export when it is registered [here](../../index.js.md#get-commands-from-commands).

**Line [4](#__codelineno-1-4):**
Defines the catagory to add it to in the 
    

``` js linenums="9"

    async execute(interaction) {
        
        const embed = new EmbedBuilder()
            .setColor('#010963')
            .setTitle('Orders')
            .setDescription('Order below. Please note that due to limitations that I can\'t be bothered writing code to go around, you can only have one ticket open at a time over all the topics.')
            /*.addFields(
                { name: 'Test', value: 'Test1', inline: false },
            )*/
            .setImage('https://cdn.discordapp.com/attachments/895031809597902898/1193570431626657852/20240107_160151.png?ex=65ad3216&is=659abd16&hm=175289e178f2cb784ce2f30ede46af5b8b6f94f361a79ad5db059be928dc85ec&')
```

``` js


        const select = new StringSelectMenuBuilder()
            .setCustomId('ticketselection')
            .setPlaceholder('Make a selection!')
            .addOptions(
                new StringSelectMenuOptionBuilder()
                    .setLabel('🎨 Graphic Design')
                    .setDescription("We bring your brand to life with creative visuals.")
                    .setValue('graphics'),
                new StringSelectMenuOptionBuilder()
                    .setLabel('🎥 Video Editing')
                    .setDescription(" Turn moments into captivating videos.")
                    .setValue('editing'),
                new StringSelectMenuOptionBuilder()
                    .setLabel('🖥️  Web Design')
                    .setDescription("Build a modern, friendly online home.")
                    .setValue('web'),
                new StringSelectMenuOptionBuilder()
                    .setLabel('📝  Script Writing')
                    .setDescription("Craft attention-grabbing stories.")
                    .setValue('script'),
            );
               
            const row = new ActionRowBuilder()
                .addComponents(select);

            var channel = interaction.channel

            await channel.send({
                content: "",
                embeds: [embed],
                components: [row],
            });

            await interaction.reply({
                content:"Embed sent successfully",
                ephemeral: true
            })

            console.log(interaction)
    }
}
```