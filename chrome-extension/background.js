// Background service worker — opens the side panel when the toolbar icon is
// clicked and installs a "Ask Soal.help" right-click item on selected text.

chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: 'soal-ask-selection',
    title: 'اسأل Soal.help عن النص المحدد',
    contexts: ['selection'],
  });
});

// Open the side panel when the toolbar icon is clicked.
chrome.sidePanel
  .setPanelBehavior({ openPanelOnActionClick: true })
  .catch((err) => console.warn('sidePanel behavior', err));

chrome.contextMenus.onClicked.addListener(async (info, tab) => {
  if (info.menuItemId !== 'soal-ask-selection' || !info.selectionText) return;
  await chrome.storage.local.set({ pending_prompt: info.selectionText });
  if (tab?.windowId != null) {
    try {
      await chrome.sidePanel.open({ windowId: tab.windowId });
    } catch (e) {
      console.warn('open side panel', e);
    }
  }
});
