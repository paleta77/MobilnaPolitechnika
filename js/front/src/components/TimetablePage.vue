 <template>
  <div id="tablePage">
    <div id="ttable">
      <div id="timetable">
        <div
          v-for="(el, index) in table"
          v-bind:key="el.el.subject"
          class="card"
          :style="{ top:el.y +'px',left:el.x +'px', 'min-height':el.height +'px'}"
        >
          <div class="header">{{el.start}} - {{el.end}}</div>
            {{el.el.subject}}
            <br/>
            <b>{{el.el.lecturer ? el.el.lecturer : ""}}</b>
            <br />
            <a href="#"><b>{{el.el.classroom}}</b></a>
        </div>
      </div>
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
import API from "../api.js";

export default {
  name: "TimetablePage",
  data: function() {
    return {
      table: []
    };
  },
  methods: {
    zero2: function(number) {
      return ("" + number).padStart(2, "0");
    },

    strhour: function(hour) {
      return this.zero2(hour[0]) + ":" + this.zero2(hour[1]);
    },

    addMinutes: function(date, minutes) {
      return [
        (date[0] + (date[1] + minutes) / 60) | 0,
        (date[1] + minutes) % 60 | 0
      ];
    },

    toHour: function(float) {
      return [float | 0, ((float % 1) * 100) | 0];
    },

    loadTable: async function() {
      let timetable = await API.timetable();

      if (timetable === null) {
        return;
      }

      this.table = [];

      let i = 1;
      for (let el of timetable) {
        let start = this.toHour(el.hour);
        let end = this.addMinutes(start, el.length);

        let x = (el.day == "Sobota" ? 0 : 430) + 100;
        let y = 80 * (start[0] + start[1] / 60 - 8) + 12 + 20;
        let height = (8 * el.length) / 6;

        this.table.push({
          x: x,
          y: y,
          height: height,
          start: this.strhour(start),
          end: this.strhour(end),
          el: el
        });
        i++;
      }
      console.log(this.table);
    }
  }
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