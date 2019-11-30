 <template>
  <div id="mapPage">
    <iframe id="mapframe" class="border" src="/nav/"></iframe>
  </div>
</template>

<script>
export default {
  name: "MapPage"
};
</script>

<style scoped>
iframe {
  width: 100%;
  height: 500px;
  border: none;
}
</style>