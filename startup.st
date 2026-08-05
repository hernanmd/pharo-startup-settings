StartupPreferencesLoader default executeAtomicItems: {			

	(StartupAction
		name: 'Show any startup action errors'
		code: [
			StartupPreferencesLoader default errors
				ifNotEmpty: [ :errors | errors inspect ] ]
		runOnce: true).

	(StartupAction
		name: 'Glamorous Toolkit Iceberg Settings'
		code: [
			(Smalltalk shortImageName beginsWith: 'Glamorous')
				ifTrue: [
					| credentials store |
					credentials := IceSshCredentials new
						host:  #'*';
						username: 'git';
						publicKey: (FileLocator home / '.ssh/id_ed25519_laptopM4.pub') pathString;
						privateKey: (FileLocator home / '.ssh/id_ed25519_laptopM4') pathString;
						yourself.
					store := IceCredentialStore current.
					store storeSshCredential: credentials forHostname: credentials host.
					IceCredentialsProvider useCustomSsh: true.
				 ] 
			]
		runOnce: true).

	(StartupAction
		name: 'Iceberg Settings'
		code: [

			Smalltalk at: #Author 
				ifPresent: [ : authorClass | authorClass fullName: 'HernanMoralesDurand' ]
				ifAbsent: [ nil ].
			Smalltalk 
				at: #IceTipCommitSettings
				ifPresent: [ : icebergClass | 
					icebergClass saveImageOnCommit: false.
					(icebergClass class canUnderstand: #critiquesOnCommit:)
						ifTrue: [ IceTipCommitSettings critiquesOnCommit: false ] ].

			"Enable loading from private repositories"
			IceCredentialsProvider providerType: IceNonInteractiveCredentialsProvider.

			Iceberg enableMetacelloIntegration: true.
			IceCredentialsProvider useCustomSsh: true.
            IceCredentialsProvider sshCredentials
                    username: 'git';
                    publicKey: (FileLocator home / '.ssh/id_ed25519_laptopM4.pub');
                    privateKey: (FileLocator home / '.ssh/id_ed25519_laptopM4').
			IceCredentialStore current
				initialize;
				"https://github.com/settings/personal-access-tokens"
				storeCredential: (IceTokenCredentials new
					username: 'hernanmd';
		 		   	token: (FileLocator home / 'git_projects/github.token' asFileReference contents trimRight);
					yourself)
				forHostname: 'github.com';
				"https://gitlab.com/-/user_settings/personal_access_tokens?page=1&state=active&sort=expires_asc"
				storeCredential: (IceTokenCredentials new
					username: 'hernanmd';
					token: (FileLocator home / 'git_projects/gitlab.token' asFileReference contents trimRight);
					yourself)
				forHostname: 'gitlab.com';
		 		yourself ]
		runOnce: true).

	(StartupAction
		name: 'Close welcome window'
		code: [
			World submorphs
				select: [ :sm | sm isSystemWindow and: [ sm label endsWith: 'Welcome' ] ] 
				thenDo: [ :window | window delete ] ]
		runOnce: true).

	(StartupAction
		name: 'Calypso settings'
		code: [
			ClySubclassHierarchy isDefaultHierarchyForMethodVisibility: true.
			(ClyTextLineNumbersSwitchMorph canUnderstand: #showLineNumbers)
				ifTrue: [ ClyTextLineNumbersSwitchMorph showLineNumbers: true ].

			Smalltalk at: #ClyCriticEnvironmentPlugin
				ifPresent: [ : clyClass | clyClass isEnabled: true ] ]
		runOnce: true).

	(StartupAction
		name: 'Debugging settings'
		code: [
			DebugSession logDebuggerStackToFile: false.
			"Deprecation showWarning: false.
			Deprecation activateTransformations: false."
			OupsDebuggerSelector handleDebuggerErrors: true.
			Smalltalk at: #OupsDebuggerSelector
				ifPresent: [ : opusClass | opusClass handleDebuggerErrors: true ].
			Smalltalk at: #StDebuggerMethodImplementorExtension 
				ifPresent: [ : debuggerExtensionClass | debuggerExtensionClass showInDebugger: false ]
				ifAbsent: [ ]  ]
		runOnce: true).

	(StartupAction
		name: 'Cursor settings'
		code: [
			RubCursor defaultWidth: 10.
			RubCursor period: 0 ]
		runOnce: true).

	(StartupAction
		name: 'Load Hack Font'
		code: [ 
			| customNormalFont customBoldFont |

			" brew install --cask font-fantasque-sans-mono "
			FreeTypeFontProvider current updateEmbeddedFreeTypeFonts. 
			FreeTypeFontProvider current updateFromSystem.

			customNormalFont := (LogicalFont
				familyName: 'Fantasque Sans Mono'
				pointSize: 11
				stretchValue: 5
				weightValue: 300
				slantValue: 0) forceNotBold.
			customBoldFont := (LogicalFont
				familyName: 'Fantasque Sans Mono'
				pointSize: 11) forceBold.

			StandardFonts setAllStandardFontsTo: customNormalFont.
			StandardFonts windowTitleFont: customBoldFont ]
		runOnce: true).
		
		(StartupAction	
			name: 'Basic Initialization'
			code: [
				PolymorphSystemSettings uiThemeClass: PharoLightTheme.
				"Author fullName: 'HernanMoralesDurand'."
				" Setup window title "
				(Smalltalk version beginsWith: 'Pharo1')
					ifTrue: [ World worldState worldRenderer windowTitle: FileLocator imageDirectory fullName.
				Smalltalk tools workspace open. ] ]
			runOnce: true).
}.
