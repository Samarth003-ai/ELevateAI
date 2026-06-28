//User cliks Register
//Should we save user?
//Check email?
//Hash password?
//Generate JWT?
//All this logic belongs inside this controller.

const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const registerUser = async (req, res) => {
    try {
        const { name, email, password } = req.body;   //take data from request body

        //check existing user
        const existingUser = await User.findOne({ email }); //findone is used to search in doxument

        if (existingUser) {
            return res.status(400).json({
                success: false,
                message: "User already exisits",
            });
        }

        const salt = await bcrypt.genSalt(10);
        const hashedpassword = await bcrypt.hash(password, salt);


        const user = await User.create({     //creates new user
            name,
            email,
            password: hashedpassword,
        });

        res.status(201).json({
            success: true,
            user
        })

    }
    catch (error) {
        res.status(500).json({
            message: error.message,
        })
    }
};

const loginUser = async (req, res) => {
    try {

        const { email, password } = req.body;
        console.log("=== LOGIN ATTEMPT ===");
        console.log("Incoming Email:", email);
        console.log("Incoming Password:", password);

        const user = await User.findOne({
            email,
        });

        if (!user) {
            console.log("Login failed: User not found in DB");
            return res.status(400).json({
                success: false,
                message: "Invalid credentials",
            });
        }

        console.log("User found in DB:", user.name, "Email:", user.email);

        const isMatch = await bcrypt.compare(password, user.password); // compares hashed password
        console.log("Password match result:", isMatch);

        if (!isMatch) {
            console.log("Login failed: Password did not match");
            return res.status(400).json({
                success: false,
                message: "Invalid credentials",
            });
        }
        console.log("Login successful!");

        const token = jwt.sign(
            {
                userId: user._id,
            },
            process.env.JWT_SECRET,
            {
                expiresIn: "7d",
            }
        );


        res.status(200).json({
            success: true,
            token
        })
    } catch (error) {

        res.status(500).json({
            message: error.message,
        });

    }
};

module.exports = {
    registerUser, loginUser
}