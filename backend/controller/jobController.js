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

exports.getJobCards = async (req, res) => {
  try {
    const jobs = await JobDetails.find(
      {},
      "company_name job_title location package role_type"
    );

    res.status(200).json({
      message: "Job cards fetched successfully",
      jobs,
    });
  } catch (error) {
    console.error("Error fetching job cards:", error);
    res.status(500).json({
      message: "Failed to fetch job cards",
      error: error.message,
    });
  }
};

exports.getJobDetailsById = async (req, res) => {
  try {
    const jobId = req.params.jobId;

    const job = await JobDetails.findById(jobId);
    if (!job) {
      return res.status(404).json({ message: "Job not found" });
    }

    res.status(200).json({
      message: "Job details fetched successfully",
      job,
    });
  } catch (error) {
    console.error("Error fetching job details:", error);
    res.status(500).json({
      message: "Failed to fetch job details",
      error: error.message,
    });
  }
};
