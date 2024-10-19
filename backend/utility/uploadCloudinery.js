const cloudinary = require('../config/cloudinary');

const uploadToCloudinary = async (file) => {
  if (!file) return null;

  try {
    const result = await cloudinary.uploader.upload(file.path, {
      resource_type: 'auto',
    });
    return result.secure_url;
  } catch (error) {
    console.error('Cloudinary upload error:', error);
    throw new Error('Failed to upload file');
  }
};

module.exports = { uploadToCloudinary };
