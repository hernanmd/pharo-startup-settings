StartupPreferencesLoader default executeAtomicItems: {			

	(StartupAction
		name: 'Show any startup action errors'
		code: [
			StartupPreferencesLoader default errors
				ifNotEmpty: [ :errors | errors inspect ] ]
		runOnce: true).

	(StartupAction
		name: 'Iceberg Settings'
		code: [

			Smalltalk at: #Author 
				ifPresent: [ : authorClass | authorClass fullName: 'HernanMoralesDurand' ]
				ifAbsent: [ nil ].
			IceTipCommitSettings saveImageOnCommit: false. 
			(IceTipCommitSettings class canUnderstand: #critiquesOnCommit:)
				ifTrue: [ IceTipCommitSettings critiquesOnCommit: false ].

			"Enable loading from private repositories"
			IceCredentialsProvider providerType: IceNonInteractiveCredentialsProvider.
			IceCredentialStore current
				initialize;
				storeCredential: (IceTokenCredentials new
					username: 'hernanmd';
		 		   	token: '/Users/mvs/git_projects/github.token' asFileReference contents trimRight;
					yourself)
				forHostname: 'github.com';
				storeCredential: (IceTokenCredentials new
					username: 'hernanmd';
					token: '/Users/mvs/git_projects/gitlab.token' asFileReference contents trimRight;
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
			ClyTextLineNumbersSwitchMorph showLineNumbers: true.
			ClyCriticEnvironmentPlugin isEnabled: true ]
		runOnce: true).

	(StartupAction
		name: 'Debugging settings'
		code: [
			DebugSession logDebuggerStackToFile: false.
			"Deprecation showWarning: false.
			Deprecation activateTransformations: false."
			OupsDebuggerSelector handleDebuggerErrors: true ]
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
