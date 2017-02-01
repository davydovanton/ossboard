import Vue from 'vue/dist/vue.js'

import "../stylesheets/main.scss";

import "script-loader!./share_buttons.js";
import "!style-loader!css-loader!../stylesheets/share_buttons.css";

window.onload = function () {
  var taskTitleTag = document.getElementById('task_title');
  var taskTitle = (taskTitleTag.textContent || taskTitleTag.innerText) + ' #ossboard';
  var config = {
    ui: {
      buttonText: '',
    },
    networks: {
      googlePlus: {
        enabled: true,
      },
      twitter: {
        enabled: true,
        description: taskTitle
      },
      facebook: {
        enabled: true,
        loadSdk: true,
        title: taskTitle
      },
      reddit: {
        enabled: true,
        title: taskTitle
      },
      email: {
        enabled: true,
        description: taskTitle
      }
    }
  }
  var share = new ShareButton('.task__share-js', config);
}

Vue.component('modal', {
  template: '#modal-template',
})

new Vue({
  el: '#import-modal',
  data: {
    showModal: false,
    hasError: false,
    errorMessage: '',
    exportingIssue: false,
    xhr: new XMLHttpRequest()
  },
  methods: {
    exportIssue: function () {
      var url = '/api/issue?issue_url=' + document.getElementById('issueUrl').value
      var self = this
      this.exportingIssue = true

      this.xhr.open('GET', url, true);
      this.xhr.setRequestHeader('Content-type', 'application/json');
      this.xhr.setRequestHeader('Accept', 'application/json');
      this.xhr.onload = function() {
        var data = JSON.parse(self.xhr.response)

        if (self.xhr.status == 200) {
          document.getElementById('task-title').value = data.title
          document.getElementById('task-repository-name').value = data.repository_name
          document.getElementById('task-issue-url').value = data.html_url
          document.getElementById('task-description').value = data.description
          document.getElementById('task-lang').value = data.lang
          self.showModal = false
        } else {
          self.hasError = true;
          self.errorMessage = 'Error: ' + data.error;
        }

        self.exportingIssue = false
      };
      this.xhr.send();
    }
  },
  created: function () {
    document.addEventListener("keydown", (e) => {
      if (this.showModal && e.keyCode == 27) {
        this.showModal = false;
      }
    });
  }
})

var agreementChackbox = document.getElementById("agreement-checkbox"),
    submitButton = document.getElementById("new-task-submit"),
    disableButtonReg = new RegExp('(\\s|^)button-disabled(\\s|$)');

if (agreementChackbox) {
  agreementChackbox.onchange = function() {
    if (agreementChackbox.checked) {
      submitButton.className = submitButton.className.replace(disableButtonReg, ' ');
    } else {
      submitButton.className += " button-disabled";
    }
  }
}

if (document.getElementById("task-preview-body")) {
  new Vue({
    el: '#task-preview-body',
    data: {
      write: true,
      preview: false,
      loadPreview: false,
      xhr: new XMLHttpRequest(),
      previewedText: document.getElementById('previewed-text'),
      taskDescription: '',
      rawBody: ''
    },
    methods: {
      displayForm: function () {
        this.write = true
        this.preview = false
        this.rawBody = ''
        this.taskDescription = document.getElementById('task-description').value
      },

      displayPreview: function () {
        this.taskDescription = document.getElementById('task-description').value
        this.write = false
        this.preview = true
        this.loadPreview = true

        var url = '/api/md_preview'
        var self = this

        this.xhr.open('POST', url, true);
        this.xhr.setRequestHeader('Content-type', 'application/json');
        this.xhr.setRequestHeader('Accept', 'application/json');

        this.xhr.onload = function() {
          var data = JSON.parse(self.xhr.response)
          self.loadPreview = false
          self.rawBody = data.text
        };

        this.xhr.send(JSON.stringify({md_text: this.taskDescription}));
      }
    }
  })
}

if (document.getElementById("js-switcher")) {
  new Vue({
    el: '#js-switcher',
    data: {
      firstCase: true,
      secondCase: false
    },
    methods: {
      displayFirstCase: function () {
        this.firstCase = true
        this.secondCase = false
      },

      displaySecondCase: function () {
        this.firstCase = false
        this.secondCase = true
      }
    }
  })
}

if (document.getElementById("task-status-select")) {
  new Vue({
    el: '#task-status-select',
    methods: {
      changeItem(event) {
        window.location = "/tasks?status=" + event.target.value;
      }
    }
  })
}
