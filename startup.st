StartupPreferencesLoader default executeAtomicItems: {			
	| fontFamilyName |

	fontFamilyName := 'Fantasque Sans Mono'.

	(StartupAction
		name: 'Show any startup action errors'
		code: [
			StartupPreferencesLoader default errors
				ifNotEmpty: [ :errors | errors inspect ] ]
		runOnce: true).

	(StartupAction
		name: 'Iceberg Settings'
		code: [
			IceTipCommitSettings saveImageOnCommit: false. 
			IceTipCommitSettings critiquesOnCommit: false.
			
			"Enable loading from private repositories"
			IceCredentialsProvider providerType: IceNonInteractiveCredentialsProvider.
			IceCredentialStore current
		        initialize;
		        storeCredential: (IceTokenCredentials new
		                username: 'hernanmd';
		                token: ('/Users/mvs/git_projects/github.token' asFileReference contents) trimRight;
		                yourself)
		        forHostname: 'github.com' ]
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
			Deprecation showWarning: false.
			Deprecation activateTransformations: false.
			OupsDebuggerSelector handleDebuggerErrors: true ]
		runOnce: true).

	(StartupAction
		name: 'Cursor settings'
		code: [
			RubCursor defaultWidth: 10.
			RubCursor period: 0.
			TextEditor blinkingCursor: false ]
		runOnce: true).

	(StartupAction
		name: 'Load Font'
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
				Author fullName: 'HernanMoralesDurand'.
				" Setup window title "
				(Smalltalk version beginsWith: 'Pharo1')
					ifTrue: [ 
						| worldRenderer |
						worldRenderer := World worldState worldRenderer.
						worldRenderer windowTitle: FileLocator imageDirectory fullName.
						worldRenderer class autoSetCanvasScaleFactor: true.
						Smalltalk tools workspace open. ] ]		
			runOnce: true).
}.
