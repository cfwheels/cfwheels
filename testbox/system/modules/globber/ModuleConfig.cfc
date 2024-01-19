component {
    
    this.name = "globber";
    this.author = "";
    this.webUrl = "https://github.com/Ortus-Solutions/globber/";

    function configure() {
        binder.map( 'globber' ).toDSL( 'globber@globber' );
    }
}
