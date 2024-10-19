const mongoose = require("mongoose");

const jobDetailsSchema = new mongoose.Schema(
  {
    company_name: {
      type: String,
      required: true,
      trim: true,
    },
    job_title: {
      type: String,
      required: true,
      trim: true,
    },
    location: {
      type: String,
      required: true,
      trim: true,
    },
    package: {
      type: Number,
      required: true,
    },
    role_type: {
      type: String,
      required: true,
      trim: true,
    },
    job_description: {
      type: String,
      required: true,
      trim: true,
    },
    minimum_cgpa: {
      type: Number,
      min: 0,
      max: 10,
    },
    number_supplies_permittable: {
      type: Number,
      min: 0,
    },
    active_backlog_allowed: {
      type: Boolean,
      default: false,
    },
    service_bond: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true, 
  }
);

const JobDetails = mongoose.model("JobDetails", jobDetailsSchema);

module.exports = JobDetails;
