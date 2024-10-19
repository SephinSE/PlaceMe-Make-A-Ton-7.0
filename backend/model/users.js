const mongoose = require('mongoose');


const userSchema = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
  },
  gender: {
    type: String,
    enum: ['Male', 'Female', 'Other'],
    trim: true,
  },
  contactNo: {
    type: String,
    trim: true,
  },
  password: {
    type: String,
    required: true,
    trim: true,
  },
  dob: {
    type: Date,
  },
  tenthPercentage: {
    type: Number,
  },
  twelthPercentage: {
    type: Number,
  },
  diplomaPercentage: {
    type: Number,
  },
  ugCgpa: {
    type: Number,
  },
  pgCgpa: {
    type: Number,
  },
  backlogs: {
    type: Number,
    default: 0,
  },
  yearOfPassing: {
    type: Number,
  },
  languagesKnown: {
    type: [String], 
    trim: true,
  },
  homeTown: {
    type: String,
    trim: true,
  },
  course: {
    type: String,
    trim: true,
  },
  schoolInstitution: {
    type: String,
    trim: true,
  },
  department: {
    type: String,
    trim: true,
  },
  resume:{
    type: String,
  },
  isPlaceCo: {
    type: Boolean,
    default: false,
  },
}, {
  timestamps: true, 
});


const User = mongoose.model('User', userSchema);

module.exports = User;
