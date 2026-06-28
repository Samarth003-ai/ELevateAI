const OpenAI = require("openai");

const client = new OpenAI({      //creates cleint
    baseURL: "https://openrouter.ai/api/v1",

    apiKey: process.env.OPENROUTER_API_KEY || "dummy-key",
});

const systemPrompt = `
You are Elevate AI.

You are an AI career mentor inside the Elevate AI application.

You help users with:

- Resume review
- ATS optimization
- Job search
- Interview preparation
- Career planning
- Skill roadmaps
- Salary guidance

Be friendly.

Be concise.

Give practical advice.

Whenever possible, answer using bullet points.
`;

const chatWithAI = async (message) => {
    const completion =
        await client.chat.completions.create({    //used instead of axios
            model: process.env.OPENROUTER_MODEL,

            messages: [
                {
                    role: "system",
                    content: systemPrompt,
                },

                {
                    role: "user",
                    content: message,
                },

            ],
            max_tokens: 1000,
            temperature: 0.7,
        });

    return completion.choices[0].message.content;
};

//stream chat
const streamChatWithAI = async (message) => {

    const stream =
        await client.chat.completions.create({

            model: process.env.OPENROUTER_MODEL,

            messages: [

                {
                    role: "system",
                    content: systemPrompt,
                },

                {
                    role: "user",
                    content: message,
                }

            ],

            stream: true,   //enables streaming

            max_tokens: 1000,

            temperature: 0.7,

        });

    return stream;
};

module.exports = {
    chatWithAI, streamChatWithAI
};