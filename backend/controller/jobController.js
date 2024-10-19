const JobDetails = require("../model/job");

exports.createJobDetails = async (req, res) => {
  try {
    const {
      company_name,
      job_title,
      location,
      package,
      role_type,
      job_description,
      minimum_cgpa,
      number_supplies_permittable,
      active_backlog_allowed,
      service_bond,
    } = req.body;

    const newJobDetail = new JobDetails({
      company_name,
      job_title,
      location,
      package,
      role_type,
      job_description,
      minimum_cgpa,
      number_supplies_permittable,
      active_backlog_allowed,
      service_bond,
    });

    await newJobDetail.save();

    res.status(201).json({
      message: "Job details created successfully",
      jobDetails: newJobDetail,
    });
  } catch (error) {
    console.error("Error creating job details:", error);
    res.status(500).json({
      message: "Failed to create job details",
      error: error.message,
    });
  }
};
