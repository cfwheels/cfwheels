<template>
<div id="app">
  <b-navbar toggleable="sm" type="light" variant="light">
    <b-navbar-toggle target="nav-text-collapse"></b-navbar-toggle>

    <b-navbar-brand>CFWheels</b-navbar-brand>

    <b-collapse id="nav-text-collapse" is-nav>
      <b-navbar-nav>
        <b-nav-text>Test Suite</b-nav-text>
      </b-navbar-nav>
    </b-collapse>
  </b-navbar>
	<router-view/>
</div>
</template>

<style lang="scss">
</style>
