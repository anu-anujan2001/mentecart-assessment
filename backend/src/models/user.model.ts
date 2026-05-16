import mangoose from 'mongoose';

const userSchema = new mangoose.Schema({
    name: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String,
        enum: ['user', 'admin'],
        default: 'user',
    },
},{
    timestamps: true,
});

const User = mangoose.model('User', userSchema);
export default User;
