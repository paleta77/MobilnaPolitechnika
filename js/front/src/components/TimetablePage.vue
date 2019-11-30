 <template>
  <div id="tablePage">
    <div id="ttable">
      <div id="timetable"></div>
      <div id="header">
        <h3>Sobota</h3>
        <h3>Niedziela</h3>
      </div>
      <div id="grid">
        <div class="grow">
          <div class="hour">08:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
        <div class="grow">
          <div class="hour">10:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
        <div class="grow">
          <div class="hour">12:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
        <div class="grow">
          <div class="hour">14:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
        <div class="grow">
          <div class="hour">16:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
        <div class="grow">
          <div class="hour">18:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
        <div class="grow">
          <div class="hour">20:00</div>
          <div class="day"></div>
          <div class="day"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "TimetablePage"
};
</script>

<style>
#ttable .card {
  border: 5px solid rgb(0, 128, 192);
  outline-offset: -5px;
  position: absolute;
  width: 400px;
  background-color: white;
}

#ttable .card .header {
  background-color: rgb(244, 244, 244);
}

#ttable #grid .grow {
  height: 160px;
  width: 100%;
}

#ttable #grid .grow:last-child .day {
  border-bottom: 1px solid black;
}

#ttable #grid .hour {
  display: inline-block;
  width: 100px;
  height: 100%;
  vertical-align: top;
  border-top: 1px solid black;
  border-right: 1px solid black;
}

#ttable #grid .day {
  display: inline-block;
  vertical-align: top;
  width: 420px;
  height: 100%;
  border-right: 1px solid black;
  border-top: 1px solid black;
}

#ttable #header {
  height: 32px;
  padding-left: 104px;
}

#ttable #header h3 {
  margin: 0 0;
  display: inline-block;
  width: 416px;
}

#ttable {
  position: relative;
  border: 1px solid #dee2e6;
  margin: 0 0;
  font-family: sans-serif;
  overflow: visible;
}
</style>