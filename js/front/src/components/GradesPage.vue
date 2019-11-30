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
      <tbody></tbody>
    </table>

    <div
      class="modal fade"
      id="changeGradeModal"
      tabindex="-1"
      role="dialog"
      aria-labelledby="changeGradeModalTitle"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLongTitle">Change grade</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <form>
              <div class="form-group">
                <label for="subjectInputChange">Subject</label>
                <input
                  type="text"
                  class="form-control"
                  id="subjectInputChange"
                  placeholder="Enter subject"
                  readonly
                />
              </div>
              <div class="form-group">
                <label for="valueInputChange">Value</label>
                <select class="form-control" id="valueInputChange">
                  <option>2</option>
                  <option>3</option>
                  <option>4</option>
                  <option>5</option>
                </select>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary" @click="changeGrade">Save changes</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "GradesPage",
  methods: {
    chnageGrade: function() {
      console.log("Change grade");
    }
  }
};
</script>

<style scoped>
</style>