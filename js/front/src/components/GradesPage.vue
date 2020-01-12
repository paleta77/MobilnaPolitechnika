 <template>
  <div id="gradesPage">
    <div class="form-group">
      <label for="ectsInput">
        <h2>Semestr</h2>
      </label>
      <select class="form-control" id="ectsInput" v-model="semester" v-on:change="selectSem">
        <option>1</option>
        <option>2</option>
        <option>3</option>
        <option>4</option>
        <option>5</option>
        <option>6</option>
        <option>7</option>
        <option>8</option>
        <option>9</option>
        <option>10</option>
        <option>11</option>
        <option>12</option>
        <option>13</option>
        <option>14</option>
        <option>15</option>
        <option>16</option>
        <option>17</option>
        <option>18</option>
        <option>19</option>
        <option>20</option>
      </select>
    </div>

    <form class="border mb-2 p-3">
      <div class="form-group">
        <label for="subjectInput">Subject</label>
        <input
          type="text"
          class="form-control"
          id="subjectInput"
          placeholder="Enter subject"
          v-model="newSubject"
        />
      </div>
      <div class="form-group">
        <label for="ectsInput">ECTS</label>
        <select class="form-control" id="ectsInput" v-model="newEcts">
          <option>0</option>
          <option>1</option>
          <option>2</option>
          <option>3</option>
          <option>4</option>
          <option>5</option>
          <option>6</option>
          <option>7</option>
          <option>8</option>
          <option>9</option>
          <option>10</option>
        </select>
      </div>
      <div class="form-group">
        <label for="valueInput">Value</label>
        <select class="form-control" id="valueInput" v-model="newValue">
          <option>2</option>
          <option>3</option>
          <option>4</option>
          <option>5</option>
        </select>
      </div>
      <button
        type="submit"
        class="btn btn-primary"
        @click="addGrade();"
        data-toggle="modal"
        data-target="#changeGradeModal"
      >Add</button>
    </form>
    <table class="table border" id="gradesTable">
      <thead>
        <tr>
          <th>#</th>
          <th>Subject</th>
          <th>ECTS</th>
          <th>Grade</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(grade, index) in grades" v-bind:key="grade.subject">
          <td>{{index+1}}</td>
          <td>{{grade.subject}}</td>
          <td>{{grade.ects}}</td>
          <td>{{grade.value}}</td>
          <td>
            <button class="btn btn-primary" @click="openChangeGrade(grade);">✎</button>
            <button class="btn btn-primary" @click="deleteGrade(grade);">🗑</button>
          </td>
        </tr>
        <tr class="bg-light">
          <td></td>
          <td></td>
          <td>
            <b>Srednia: {{average}}</b>
          </td>
          <td></td>
          <td></td>
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
          <label for="ectsInputChange">ECTS</label>
          <select class="form-control" id="ectsInputChange" v-model="changeEcts">
            <option>0</option>
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5</option>
            <option>6</option>
            <option>7</option>
            <option>8</option>
            <option>9</option>
            <option>10</option>
          </select>
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
import User from "../user.js";

export default {
  name: "GradesPage",
  data: function() {
    return {
      semester: 1,
      grades: [],
      showChangeModal: false,
      newSubject: "", // holds subject name from Add panel
      newEcts: "",
      newValue: "",
      changeSubject: "", // holds subject name from change grade
      changeEcts: "",
      changeValue: "",
      average: 0
    };
  },
  methods: {
    selectSem: async function() {
      this.loadGrades();
    },
    loadGrades: async function() {
      let grades = await API.getGrades();

      this.grades = grades.filter(v => v.semester == parseInt(this.semester));

      let sum = 0;
      let number = 0;
      for (let grade of this.grades) {
        sum += parseFloat(grade.ects) * parseFloat(grade.value);
        number += parseFloat(grade.ects);
      }
      this.average = sum / number;
    },

    openChangeGrade: function(grade) {
      console.log(grade);
      this.showChangeModal = true;
      this.changeSubject = grade.subject;
      this.changeEcts = grade.ects;
      this.changeValue = grade.value;
      this.$bvModal.show("changeGradeModal");
    },

    deleteGrade: async function(grade) {
      await API.deleteGrade(User.name, this.semester, grade.subject);
      this.loadGrades();
    },

    changeGrade: async function() {
      await API.changeGrade(
        User.name,
        this.semester,
        this.changeSubject,
        this.changeEcts,
        this.changeValue
      );
      this.loadGrades();
    },

    addGrade: async function() {
    let bool = await API.addGrade(
        User.name,
        this.semester,
        this.newSubject,
        this.newEcts,
        this.newValue
      );
      if (bool == false) {
        alert(API.msg);
      }
      this.loadGrades();
    }
  }
};
</script>

<style scoped>
</style>