package eu.europa.ec.epso.talent.admin.coldfusion;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Pattern;
import java.util.concurrent.TimeUnit;

import org.apache.commons.io.FileUtils;
import org.h2.tools.Server;
import org.junit.*;

import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;

import org.openqa.selenium.*;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import org.openqa.selenium.support.ui.Select;

public class ColdFusionLoadedIT {
	private WebDriver driver;
	private String baseUrl;
	private StringBuffer verificationErrors = new StringBuffer();
	Server server;
	@Before
	public void setUp() throws Exception {
//		String[] args = null;
//		server = Server.startTcpServer(args);
//		FileUtils.deleteDirectory(new File("target/db"));
		Class.forName("org.h2.Driver");
		execute("DROP ALL OBJECTS");
//		execute("CREATE TABLE USERS(ID INT PRIMARY KEY, USERNAME VARCHAR(255))");

		Path path = Paths.get("target/failsafe-reports");
		if (!Files.exists(path)) Files.createDirectory(path);
		driver = new HtmlUnitDriver();
		baseUrl = "http://localhost:8080/";
		driver.manage().timeouts().implicitlyWait(30000, TimeUnit.SECONDS);
	}

	private void execute(String sql) throws SQLException {
		try (Connection conn = DriverManager.getConnection("jdbc:h2:./target/db/test;AUTO_SERVER=TRUE;MODE=MSSQLServer","sa","")) {
			Statement statement = conn.createStatement();
			statement.execute(sql);
		}
	}

	@Test
	public void testWheelsCacheIT() throws Exception {
		processWheelsPackage("cache");
	}

	@Test
	public void testWheelsControllerCachingIT() throws Exception {
		processWheelsPackage("controller.caching");
	}

	@Test
	public void testWheelsControllerFiltersIT() throws Exception {
		processWheelsPackage("controller.filters");
	}

	@Test
	public void testWheelsControllerFlashIT() throws Exception {
		processWheelsPackage("controller.flash");
	}

	@Test
	public void testWheelsControllerInitializationIT() throws Exception {
		processWheelsPackage("controller.initialization");
	}

	@Test
	public void testWheelsControllerMiscellaneousIT() throws Exception {
		processWheelsPackage("controller.miscellaneous");
	}

	@Test
	public void testWheelsControllerProvidesIT() throws Exception {
		processWheelsPackage("controller.provides");
	}

	@Test
	public void testWheelsControllerRedirectionIT() throws Exception {
		processWheelsPackage("controller.redirection");
	}

	@Test
	public void testWheelsControllerRenderingIT() throws Exception {
		processWheelsPackage("controller.rendering");
	}

	@Test
	public void testWheelsControllerRequestIT() throws Exception {
		processWheelsPackage("controller.request");
	}

	@Test
	public void testWheelsDispatchIT() throws Exception {
		processWheelsPackage("dispatch");
	}

	@Test
	public void testWheelsGlobalIT() throws Exception {
		processWheelsPackage("global");
	}
	
	@Test
	public void testWheelsInternalIT() throws Exception {
		processWheelsPackage("internal");
	}

	@Test
	public void testWheelsModelIT() throws Exception {
		processWheelsPackage("model");
	}

	@Test
	public void testWheelsPluginsIT() throws Exception {
		processWheelsPackage("plugins");
	}

	@Test
	public void testWheelsRoutingIT() throws Exception {
		processWheelsPackage("routing");
	}

	@Test
	public void testWheelsViewIT() throws Exception {
		processWheelsPackage("view");
	}

	private void processWheelsPackage(String packageName) throws IOException {
		driver.get(baseUrl + "index.cfm?controller=wheels&action=wheels&view=tests&type=core&reload=true&package="+packageName);
        String pageSource = driver.getPageSource();
		Files.write(Paths.get("target/failsafe-reports/cfwheels-" + packageName + ".html"), pageSource.getBytes());
        assertTrue("The page should have results",pageSource.trim().length()>0);
        assertTrue("The page should have passed",pageSource.toLowerCase().contains("passed"));
	}

	@After
	public void tearDown() throws Exception {
		driver.quit();
//		execute("DROP TABLE USERS");
//		server.stop();
		String verificationErrorString = verificationErrors.toString();
		if (!"".equals(verificationErrorString)) {
			fail(verificationErrorString);
		}
	}

	private boolean isElementPresent(By by) {
		try {
			driver.findElement(by);
			return true;
		} catch (NoSuchElementException e) {
			return false;
		}
	}
}
