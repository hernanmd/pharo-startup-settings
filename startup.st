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
		name: 'Load Fantasque Sans Mono Font'
		code: [ 
			FreeTypeFontProvider current updateEmbeddedFreeTypeFonts. 
			FreeTypeFontProvider current updateFromSystem.
		
			StandardFonts
				defaultFont: (LogicalFont
					familyName: 'Fantasque Sans Mono'
					pointSize: 11
					stretchValue: 5
					weightValue: 400
					slantValue: 0).
"			GraphicFontSettings resetAllFontToDefault."
			StandardFonts
				codeFont: (LogicalFont
					familyName: 'Fantasque Sans Mono'
					pointSize: 11
					stretchValue: 5
					weightValue: 300
					slantValue: 0) forceNotBold.
			StandardFonts
				windowTitleFont: (LogicalFont
					familyName: 'Fantasque Sans Mono'
					pointSize: 11) forceBold ]
		runOnce: true).
		
		(StartupAction	
			name: 'Basic Initialization'
			code: [
				Author fullName: 'HernanMoralesDurand'.
				" Setup window title "
				(Smalltalk version beginsWith: 'Pharo1')
					ifTrue: [ World worldState worldRenderer windowTitle: FileLocator imageDirectory fullName.
				Smalltalk tools workspace open. ] ]		
			runOnce: true).
}.
