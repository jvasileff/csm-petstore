package sandbox.ceylon.snap.spring.web.config;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URISyntaxException;

import javax.servlet.ServletContext;

import com.redhat.ceylon.compiler.java.runtime.tools.Backend;
import com.redhat.ceylon.compiler.java.runtime.tools.CeylonToolProvider;
import com.redhat.ceylon.compiler.java.runtime.tools.Runner;
import com.redhat.ceylon.compiler.java.runtime.tools.RunnerOptions;

public class CeylonConfig {

	public static void setup(ServletContext ctx) {
		try {
			final File repo = new File(ctx.getResource("/WEB-INF/lib").toURI());
			RunnerOptions options = new RunnerOptions();
			options.setOffline(true);
			options.setSystemRepository("flat:" + repo.getAbsolutePath());

			String module = "sandbox.ceylon.snap.spring";
			String version = "0.0.1";
			Runner runner = CeylonToolProvider.getRunner(Backend.Java, options, module, version);

			runner.run();
		} catch (MalformedURLException | URISyntaxException e) {
			throw new RuntimeException(e);
		}
	}

}
