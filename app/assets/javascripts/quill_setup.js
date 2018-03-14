var quill = {
  theme: 'snow',
  modules: {
    toolbar: [
      [{ 'header': [1, 2, 3, false] }],
      ['bold', 'italic', 'underline'],
      ['blockquote', 'image'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      ['clean']
    ]
  },
  placeholder: 'Unleash your Twirly',
};

//This is the global config object
Quilljs.setDefaults(quill)
