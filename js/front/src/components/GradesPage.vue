 <template>
  <div id="gradesPage">
    <form class="border mb-2 p-3">
      <div class="form-group">
        <label for="subjectInput">Subject</label>
        <input type="text" class="form-control" id="subjectInput" placeholder="Enter subject" />
      </div>
      <div class="form-group">
        <label for="valueInput">Value</label>
        <select class="form-control" id="valueInput">
          <option>2</option>
          <option>3</option>
          <option>4</option>
          <option>5</option>
        </select>
      </div>
      <button
        type="submit"
        class="btn btn-primary"
        onclick="addGrade();"
        data-toggle="modal"
        data-target="#changeGradeModal"
      >Add</button>
    </form>
    <table class="table border" id="gradesTable">
      <thead>
        <tr>
          <th>#</th>
          <th>Subject</th>
          <th>Grade</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(grade, index) in grades" v-bind:key="grade.subject">
          <td>{{index+1}}</td>
          <td>{{grade.subject}}</td>
          <td>{{grade.value}}</td>
          <td>
            <button class="btn btn-primary" @click="openChangeGrade(grade);">✎</button>
            <button class="btn btn-primary" @click="deleteGrade(grade);">🗑</button>
          </td>
        </tr>
      </tbody>
    </table>

    <b-modal id="changeGradeModal" title="ChangeGrade" @ok="changeGrade">
      <form>
        <div class="form-group">
          <label for="subjectInputChange">Subject</label>
          <input
            type="text"
            class="form-control"
            id="subjectInputChange"
            placeholder="Enter subject"
            v-model="changeSubject"
            readonly
          />
        </div>
        <div class="form-group">
          <label for="valueInputChange">Value</label>
          <select class="form-control" id="valueInputChange" v-model="changeValue">
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
          </select>
        </div>
      </form>
       </b-modal>
  </div>
</template>

<script>
import API from "../api.js";

export default {
  name: "GradesPage",
  data: function() {
    return {
      grades: [{ subject: "abc", value: 5 }],
      showChangeModal: false,
      changeSubject: "",
      changeValue: ""
    };
  },
  methods: {
    loadGrades: async function() {
      console.log("test");
      let grades = await API.getGrades(); //lista z obiektami
      this.grades = grades;
      console.log("Load grade");
    },

    openChangeGrade: function(grade) {
      console.log(grade);
      this.showChangeModal = true;
      this.$bvModal.show("changeGradeModal").then(value => {
            console.log("zmakneice " + value)
          })
    },

    deleteGrade: async function() {
      await api.deleteGrade(username, subject);
      loadGrade();
      console.log("Delete grade");
    },

    changeGrade: async function() {
      await api.changeGrade(username, subject, grade);
      loadGrade();
      console.log("Change grade");
    },

    addGrade: async function() {
      let subject = $("#subjectInput").value();
      let value = parseFloat($("#valueInput").val());
      await api.addGrade(username, subject, value);
      loadGrades();
    }
  }
};

/*
async function loadGrades() {
    let grades = await api.getGrades(username);

    $('#gradesTable tbody').empty();

    let sum = 0;
    let i = 1;
    for (let grade of grades) {
        $('#gradesTable tbody').append(`
        <tr>
            <td>${i}</td>
            <td>${grade.subject}</td>
            <td>${grade.value}</td>
            <td>
                <button class="btn btn-primary" onclick="openChangeGrade('${grade.subject}', ${grade.value});">✎</button>
                <button class="btn btn-primary" onclick="deleteGrade('${grade.subject}');">🗑</button>
            </td>
        </tr>`);
        i++;
        sum += grade.value;
    }

    if (i == 1) {
        $('#gradesTable tbody').append(`<tr><td colspan="4">None</td></tr>`);
    } else {
        let average = sum / (i - 1);
        $('#gradesTable tbody').append(`<tr><td colspan="4">average: ${average}</td></tr>`);
    }
}

async function deleteGrade(subject) {
    await api.deleteGrade(username, subject);
    loadGrades();
}
window.deleteGrade = deleteGrade;

async function addGrade() {
    let subject = $('#subjectInput').val();
    let value = parseFloat($('#valueInput').val());
    await api.addGrade(username, subject, value);
    loadGrades();
}
window.addGrade = addGrade;

function openChangeGrade(subject, value) {
    $('#changeGradeModal').modal('show');
    $('#subjectInputChange').val(subject);
    $('#valueInputChange').val(value);
}
window.openChangeGrade = openChangeGrade;

async function changeGrade() {
    await api.changeGrade(username, $('#subjectInputChange').val(), $('#valueInputChange').val());
    $('#changeGradeModal').modal('hide');
    loadGrades();
}
window.changeGrade = changeGrade;*/
</script>

<style scoped>
</style>