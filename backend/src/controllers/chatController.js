const { chatWithAI, streamChatWithAI } =
    require("../services/aiService");

const chat = async (req, res) => {

    try {

        const { message } = req.body;

        if (!message) {

            return res.status(400).json({
                success: false,
                message: "Message is required",
            });

        }

        const reply =
            await chatWithAI(message);

        res.json({

            success: true,

            reply,

        });

    } catch (error) {

        res.status(500).json({

            success: false,

            message: error.message,

        });

    }

};

const streamChat = async (req, res) => {

    try {

        const { message } = req.body;

        if (!message) {

            return res.status(400).json({
                success: false,
                message: "Message is required",
            });

        }

        res.setHeader("Content-Type", "text/event-stream");
        res.setHeader("Cache-Control", "no-cache");
        res.setHeader("Connection", "keep-alive");

        const stream =
            await streamChatWithAI(message);

        for await (const chunk of stream) {

            const token =
                chunk.choices[0]?.delta?.content;

            if (token) {

                res.write(`data: ${token}\n\n`);  //sendds immediately as text arrives doesnt wait like re.json

            }

        }

        res.write("data: [DONE]\n\n");

        res.end();

    } catch (error) {

        console.error(error);

        res.end();

    }

};

module.exports = {
    chat, streamChat
};